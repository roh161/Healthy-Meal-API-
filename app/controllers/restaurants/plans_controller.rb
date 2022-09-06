module Restaurants
    class PlansController < ApplicationController
        load_and_authorize_resource

        def index
            @plans = Plan.all
            render json: { All_Plans: show_plans }, status: 200
        end

        def show
            @plan = Plan.find(params[:id])
            render json: { Plan: @plan}  
        end

        def create
            @plan = Plan.new(plan_params)
            params_for_plan  
            check_errors(@plan_cost, @plan_duration)  
            return render json: { message: @errors }, status: 406 if @if_error
            if @plan.save
                render json: { message: 'Plan Created Successfully', plan: @plan }, status: 201
            else
                render json: { message: @plan.errors.messages }, status: 406
            end
        end

        def destroy
            @plan = Plan.find(params[:id])
            @plan.destroy
            render json: { message: 'Plan Deleted Successfully' }, status: 200
        end

        def update 
            @plan = Plan.find(params[:id])  
            if @plan.update(plan_params)
                render json: { message: 'plan updated', plan: @plan }, status: 200
            else
                render json: { message: @plan.errors.messages }, status: 406
            end
        end

        def check_errors(cost, duration)
            if cost < 1000
                @if_error = true
                @errors[:plan_cost] = 'Cost of the plan must be larger than 1000'
            end
            unless [7, 14, 21].include? duration
                @if_error = true
                @errors[:plan_duration] = 'Duration must be 7, 14 or 21'
            end
            @if_error
        end
        
        def params_for_plan
            @plan_cost = params[:plan][:plan_cost].to_i
            @plan_duration = params[:plan][:plan_duration].to_i
            @plan_meals = params[:plan][:plan_meals]
            @errors = {}
            @if_error = false
        end

        def active_users   
            users = User.where(active_plan: true)
            render json: {users: users}
        end

        def activated_users
            active_plan= AcivePlan.where(plan_id: @plan.id)
            users=[]
            active_plan.each do|active_plan|
                user= User.find(active_plan.user_id)
                users << user
            end
            render json: {activated_users: users }
        end

        def buy_plan
            if current_user.active_plan
                send_plan_is_activated_response
            else           
                @plan_duration = generate_time(Date.today.next_day(@plan.plan_duration))
                user = User.find(current_user.id)
                @expiry_date = Date.today.next_day(@plan.plan_duration)-1
                @activate_plan = ActivePlan.create(user_id: current_user.id, plan_id: @plan.id)
                send_plan_is_purchased_response
            end
        end

        def send_plan_is_purchased_response
            if @activate_plan.save
              if current_user.update(active_plan: true, plan_duration: @plan_duration, expiry_date: @expiry_date)
                render json: { message: 'Plan is Successfully Purchased', bill: generate_bill }, status: 200
              else
                render json: { message: 'something wrong' }, status: 500
              end
            else
              render json: { message: 'something wrong try again' }, status: 500
            end
        end

        def send_plan_is_activated_response
            render json: { message: "Your plan is already activated try to buy after #{current_user.expiry_date}",
                              plan_expires_on: current_user.expiry_date,
                              plan: plan_url(@plan) }, status: 406
        end

        def generate_bill
            {
              plan_name: @plan.name,
              plan_description: @plan.description,
              plan_cost: @plan.plan_cost,
              plan_duration: @plan.plan_duration,
              expiry_date: @expiry_date
            }
        end

        def show_plans
            plans = []
            @plans.each do |plan|
                plans << create_plan(plan)
            end
            plans
        end
      
        def create_plan(plan)
            {
              id: plan.id,
              name: plan.name,
              description: plan.description,
              plan_duration: plan.plan_duration,
              plan_cost: plan.plan_cost,
              view_url: plan_url(plan),
              buy_url: buy_plan_url(plan)
            }
        end

        def add_meal(meals)
            category = 1
            recipes = Recipe.all.ids
            meals.each do |meal, recipe|
              if %w[morning_snacks lunch afternoon_snacks dinner hydration].include? meal
                if recipes.include? recipe
                  @meal = Meal.new(day_id: @day.id, meal_category_id: category, recipe_id: recipe.to_i)
                  @meal.save
                  category += 1
                else
                  @is_error = true
                  destroy_plan
                  @errors[:recipe] = 'the recipe that you give is not found first create it'
                end
              else
                @is_error = true
                destroy_plan
                @errors[:meal] = 'please enter all meal schedule corretly'
              end
            end
        end

        def add_days(day_meals)
            for_day = 1
            day_meals.each do |day|
              @day = Day.new(for_day: for_day.to_i, plan_id: @plan.id)
              if @day.save
                add_meal(day)
                for_day += 1
              end
            end
        end

        def show_plan_day
            plan_meals = []
            @plan.days.each do |day|
              plan_meal = {}
              plan_meal[:day] = day.for_day
              day.meals.each do |meal|
                plan_meal[meal.meal_category.name] = give_recipe(meal.recipe)
              end
              plan_meals << plan_meal
            end
            plan_meals
        end
      
        
        private

        def plan_params
            params.require(:plan).permit(:name, :description, :plan_duration, :plan_cost)
        end

    end

end

