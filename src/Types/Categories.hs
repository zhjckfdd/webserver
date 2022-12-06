module Types.Categories where

import Data.Aeson
import Database.PostgreSQL.Simple.FromRow

data EntityCategory = Category
  { id :: Int,
    categoryName :: String,
    canCreateCategory :: Bool
  }

instance FromRow EntityCategory where
  fromRow = Category <$> field <*> field <*> field

instance ToJSON EntityCategory where
  toJSON (Category categoryId categoryName canCreateCategory) =
    object
      [ "id" .= categoryId,
        "categoryName" .= categoryName,
        "canCreateCategory" .= canCreateCategory
      ]
