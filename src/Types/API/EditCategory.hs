module Types.API.EditCategory where

import Control.Monad (mzero)
import Data.Aeson

data EditCategoryReq = EditCategoryReq
  { categoryId :: Int,
    categoryName :: String
  }

instance FromJSON EditCategoryReq where
  parseJSON (Object json) = do
    categoryId <- json .: "id"
    categoryName <- json .: "category_name"
    pure (EditCategoryReq categoryId categoryName)
  parseJSON _ = mzero
