module Api
  module V1
    class ItemsController < Api::V1::AuthController
      before_action :set_list
      before_action :set_item, except: [:index, :create]
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def index
        render json: @list.items, each_serializer: ItemSerializer
      end

      def create
        item = @list.items.build(item_params)
        if item.save
          render json: item
          # if item.list.items.done.count == 1
          #   item.list.update_attribute(:currency, session[:currency])
          #   disable_currency_select = true
          # end
        else
          render json: {errors: item.errors.full_messages.to_sentence }, status: :expectation_failed
        end
      end

      def update
        if @item.update(item_params)
          render json: @item
        #   if list.items.done.count == 1
        #     item.list.update_attribute(:currency, session[:currency])
        #   end
        else
          render json: {errors: @item.errors.full_messages.to_sentence }, status: :expectation_failed
        end
      end

      def destroy
        @item.destroy
        head :ok
      end

      def toggle_done
        if @item.toggle!(:done)
          render json: @item
        else
          render json: {errors: @item.errors.full_messages.to_sentence }, status: :expectation_failed
        end
      end

      private

      def set_list
        @list = List.find(params[:list_id])
      end
      
      def set_item
        @item = @list.items.find(params[:id])
      end

      def item_params
        params.require(:item).permit(:id, :name, :price, :done, :_destroy, :category_id, :currency, :description, :list_id)
      end

      def not_found
        # byebug
        render json: {error: "List #{I18n.t('errors.messages.not_found')}" }, status: :not_found
      end

    end
  end
end
