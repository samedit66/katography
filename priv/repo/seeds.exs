# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Katography.Repo.insert!(%Katography.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Katography.Context.{Pages, Folders, Pictures, PageFolders, FolderPictures}

{:ok, page} = Pages.create(%{name: "Page 1"})

{:ok, folder} = Folders.create(%{name: "Folder 1", path: "pictures"})

{:ok, _page_folder} = PageFolders.create(%{page_id: page.id, folder_id: folder.id})

{:ok, picture} = Pictures.create(%{filename: "first.jpg"})

{:ok, _folder_picture} = FolderPictures.create(%{folder_id: folder.id, picture_id: picture.id})
