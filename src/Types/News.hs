module Types.News where

import Data.Aeson
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple.FromRow

data EntityNews = News
  { id :: Int,
    shortTitle :: String,
    dateOfCreation :: UTCTime,
    creatorId :: Int,
    categoryId :: Int,
    content :: String,
    photo :: Int,
    publishedNews :: Bool
  }

instance FromRow EntityNews where
  fromRow = News <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field

instance ToJSON EntityNews where
  toJSON (News newsId titleNews dateNews creatorNews categoryId contentNews photoNews publishedNews) =
    object
      [ "id" .= newsId,
        "shortTitle" .= titleNews,
        "dateOfCreation" .= dateNews,
        "creatorId" .= creatorNews,
        "categoryId" .= categoryId,
        "content" .= contentNews,
        "photo" .= photoNews,
        "publishedNews" .= publishedNews
      ]
