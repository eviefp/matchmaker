module Web.Types where

import Database.PostgreSQL.Entity.DBT
import Web.Session (ScottySM, UserAssigns)

newtype WebM a
  = WebM { getWeb :: ReaderT WebEnvironment IO a }
  deriving newtype (Applicative, Functor, Monad, MonadIO, MonadReader WebEnvironment)

data WebEnvironment
  = WebEnvironment { sessions      :: ScottySM UserAssigns
                   , pgPool        :: ConnectionPool
                   , templateCache :: HashMap String String
                   }

runWebM :: WebEnvironment -> WebM a -> IO a
runWebM env action =
  runReaderT (getWeb action) env