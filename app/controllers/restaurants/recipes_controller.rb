module Restaurants
    class RecipesController < ApplicationController
        load_and_authorize_resource
        def index
            @recipes = Recipe.all
            render json: { All_Recipe: @recipes }, status: 200
        end

        def show
            @recipe = Recipe.find(params[:id])
            render json: { recipe: @recipe }
        end

        def create
            @recipe = Recipe.new(recipe_params)
            if @recipe.save
                render json: { message: 'Recipe Created Successfully', recipe: @recipe }, status: 201
            else
                render json: { message: @recipe.errors.messages }, status: 406
            end
        end

        def destroy
            @recipe = Recipe.find(params[:id])  
            @recipe.destroy
            render json: { message: 'Recipe Deleted Successfully' }, status: 200
        end

        def update
            @recipe = Recipe.find(params[:id])
            if @recipe.update(recipe_params)
                render json: { message: 'Recipe Updated Successfully', recipe: @recipe }, status: 200
            else
                render json: { message: @recipe.errors.messages }, status: 406
            end
        end
        
        private

        def recipe_params
            params.require(:recipe).permit(:name,:description,:ingredients)
        end

    end
end