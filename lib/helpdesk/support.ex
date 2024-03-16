defmodule Helpdesk.Support do
  use Ash.Api

  resources do
    resource Helpdesk.Support.Ticket
    resource Helpdesk.Support.Representative
  end
end
