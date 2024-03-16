defmodule Helpdesk.Support.Ticket do
  # This turns this module into a resource
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets

  actions do
    # Add a set of simple actions. You'll customize these later.
    defaults [:create, :read, :update, :destroy]

    create :open do
      accept [:subject, :representative_id]
    end

    update :close do
      # We don't want to accept any input here
      accept []

      change set_attribute(:status, :closed)
      # A custom change could be added like so:
      #
      # change MyCustomChange
      # change {MyCustomChange, opt: :val}
    end

    update :assign do
      # No attributes should be accepted
      accept []

      # We accept a representative's id as input here
      argument :representative_id, :uuid do
        # This action requires representative_id
        allow_nil? false
      end

      # We use a change here to replace the related Representative
      # If there is a different representative for this Ticket, it will be changed to the new one
      # The Representative itself is not modified in any way
      change manage_relationship(:representative_id, :representative, type: :append_and_remove)
    end
  end

  # Attributes are the simple pieces of data that exist on your resource
  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_primary_key :id

    # Add a string type attribute called `:subject`
    attribute :subject, :string do
      allow_nil? false
    end

    attribute :status, :atom do
      constraints one_of: [:open, :closed]

      # The status defaulting to open makes sense
      default :open

      # We also don't want status to ever be `nil`
      allow_nil? false
    end
  end

  relationships do
    belongs_to :representative, Helpdesk.Support.Representative do
      # We don't want to allow a nil representative_id
      attribute_writable? true
    end
  end
end