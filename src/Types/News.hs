module Types.News where

import Data.Aeson
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple.FromRow

data EntityNews = News
  { id :: Int,
    shortTitle :: String,
    dateOfCreation :: UTCTime,
    creatorId :: Int,
    category :: String,
    content :: String,
    photo :: Int,
    publishedNews :: Bool
  }

instance FromRow EntityNews where
  fromRow = News <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field

instance ToJSON EntityNews where
  toJSON (News newsId titleNews dateNews creatorNews categoryNews contentNews photoNews publishedNews) =
    object
      [ "id" .= newsId,
        "shortTitle" .= titleNews,
        "dateOfCreation" .= dateNews,
        "creatorId" .= creatorNews,
        "category" .= categoryNews,
        "content" .= contentNews,
        "photo" .= photoNews,
        "publishedNews" .= publishedNews
      ]
