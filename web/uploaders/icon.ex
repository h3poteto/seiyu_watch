defmodule SeiyuWatch.Icon do
  use Arc.Definition
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :small]

  @acl :public_read

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # TODO: resize
  # Define a thumbnail transformation:
  def transform(:small, _) do
    {:convert, "-strip -resize 100x"}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "system/icons/seiyu/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    "/images/noimage.png"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
