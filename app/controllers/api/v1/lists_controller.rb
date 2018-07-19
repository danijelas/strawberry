module Api
  module V1
    class ListsController < Api::V1::AuthController

      before_action :set_list, except: [:index, :create]
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      
      def index
        render json: current_user.lists, each_serializer: ListSerializer
      end

      def create
        list = current_user.lists.build(list_params)
        if list.save
          render json: list
        else
          render json: {errors: list.errors.full_messages.to_sentence }, status: :expectation_failed
        end
      end

      def update
        if @list.update(list_params)
          render json: @list
        else
          render json: {errors: @list.errors.full_messages.to_sentence }, status: :expectation_failed
        end
      end

      def destroy
        @list.destroy
        head :ok
      end

      private

      def set_list
        @list = List.find(params[:id])
      end

      def list_params
        params.require(:list).permit(:name, :currency)
      end

      def not_found
        # byebug
        render json: {error: "List #{I18n.t('errors.messages.not_found')}" }, status: :not_found
      end

    end
  end
end
