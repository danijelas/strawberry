module Api
  module V1
    class CategoriesController < Api::V1::AuthController
      before_action :set_category, except: [:index, :create]
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def index
        render json: current_user.categories.order(:id), each_serializer: CategorySerializer
      end

      def create
        category = current_user.categories.build(category_params)
        if category.save
          render json: category
        else
          render json: {errors: category.errors.full_messages.to_sentence }, status: :expectation_failed
        end
      end

      def update
        if @category.update(category_params)
          render json: @category
        else
          render json: {errors: @category.errors.full_messages.to_sentence }, status: :expectation_failed
        end
      end

      def destroy
        @category.destroy
        head :ok
      end

      private
    
      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end

      def not_found
        render json: {error: "List #{I18n.t('errors.messages.not_found')}" }, status: :not_found
      end

    end
  end
end
