module Types.Categories where

import Data.Aeson
import Database.PostgreSQL.Simple.FromRow

data EntityCategory = Category
  { idCategory :: Int,
    categoryName :: String,
    canCreateCategory :: Bool
  }

instance FromRow EntityCategory where
  fromRow = Category <$> field <*> field <*> field

instance ToJSON EntityCategory where
  toJSON (Category categoryId categoryName canCreateCategory) =
    object
      [ "idCategory" .= categoryId,
        "categoryName" .= categoryName,
        "canCreateCategory" .= canCreateCategory
      ]
