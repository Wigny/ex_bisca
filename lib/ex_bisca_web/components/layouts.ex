defmodule ExBiscaWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use ExBiscaWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app>
        <h1>Content</h1>
      </Layouts.app>

  """

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <main>{render_slot(@inner_block)}</main>
    """
  end
end
