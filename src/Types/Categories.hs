module Types.Categories where

import Data.Aeson
import Database.PostgreSQL.Simple.FromRow

data EntityCategory = Category
  { id :: Int,
    categoryName :: String
  }

instance FromRow EntityCategory where
  fromRow = Category <$> field <*> field

instance ToJSON EntityCategory where
  toJSON (Category categoryId categoryName) =
    object
      [ "id" .= categoryId,
        "categoryName" .= categoryName
      ]
