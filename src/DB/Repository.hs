module DB.Repository where

import Data.Aeson (FromJSON, ToJSON)
import Data.Time (UTCTime)
import Data.UUID (UUID)
import Database.PostgreSQL.Entity (delete, insert, selectById,
                                   selectManyByField, selectOneByField)
import Database.PostgreSQL.Entity.Types
import Database.PostgreSQL.Simple (FromRow, Only (Only), ToRow)
import Database.PostgreSQL.Simple.FromField (FromField)
import Database.PostgreSQL.Simple.ToField (ToField)
import Database.PostgreSQL.Transact (DBT)

import DB.Organisation (OrganisationId (..))
import Data.Vector (Vector)

newtype RepositoryId
  = RepositoryId { getRepositoryId :: UUID }
  deriving stock (Eq, Generic)
  deriving newtype (FromField, FromJSON, Show, ToField, ToJSON)

data Repository
  = Repository { repositoryId          :: RepositoryId
               , organisationId        :: OrganisationId
               , repositoryName        :: Text
               , repositoryDescription :: Text
               , repositoryURL         :: Text
               , repositoryHomepage    :: Maybe Text
               , createdAt             :: UTCTime
               , updatedAt             :: UTCTime
               }
    deriving stock (Eq, Generic, Show)
    deriving anyclass (FromRow, ToRow)
    deriving (Entity)
      via (GenericEntity '[TableName "repositories"] Repository)

insertRepository :: Repository -> DBT IO ()
insertRepository repo = insert @Repository repo

getRepository :: RepositoryId -> DBT IO (Maybe Repository)
getRepository repoId = selectById @Repository (Only repoId)

getRepositoriesByOrg :: OrganisationId -> DBT IO (Vector Repository)
getRepositoriesByOrg orgId = selectManyByField @Repository "organisation_id" (Only orgId)

getRepositoryByName :: Text -> DBT IO (Maybe Repository)
getRepositoryByName name = selectOneByField "repository_name" (Only name)

deleteRepository :: RepositoryId -> DBT IO ()
deleteRepository repoId = delete @Repository (Only repoId)
