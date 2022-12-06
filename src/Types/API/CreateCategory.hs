module Types.API.CreateCategory where

import Control.Monad (mzero)
import Data.Aeson

newtype CreateCategoryReq = CreateCategoryReq
  { categoryName :: String
  }

instance FromJSON CreateCategoryReq where
  parseJSON (Object json) = do
    categoryName <- json .: "category_name"
    pure (CreateCategoryReq categoryName)
  parseJSON _ = mzero
