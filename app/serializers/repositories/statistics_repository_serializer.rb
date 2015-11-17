module Repositories
  class StatisticsRepositorySerializer < ActiveModel::Serializer
    attributes :commercialProjects, :internalProjects, :maintenanceProjects, :projectsEndingBetween,
      :beginningSoonProjects, :seniorAndroidDevs, :seniorIosDevs, :seniorRorDevs, :androidDevs,
      :iosDevs, :rorDevs, :developersInInternals, :interns, :juniorRor, :juniorIos, :juniorAndroid,
      :nonBillableInCommercialProjects, :juniorFrontendDevs, :frontendDevs, :seniorFrontendDevs,
      :designers, :seniorDesigners, :juniorProjectManagers, :projectManagers,
      :seniorProjectManagers

    def commercialProjects
      ActiveModel::ArraySerializer.new(object.commercial_projects,
        each_serializer: Api::V2::ProjectStatisticsSerializer)
    end

    def internalProjects
      ActiveModel::ArraySerializer.new(object.internal_projects,
        each_serializer: Api::V2::ProjectStatisticsSerializer)
    end

    def maintenanceProjects
      ActiveModel::ArraySerializer.new(object.maintenance_projects,
        each_serializer: Api::V2::ProjectStatisticsSerializer)
    end

    def projectsEndingBetween
      ActiveModel::ArraySerializer.new(object.projects_ending_between,
        each_serializer: Api::V2::ProjectStatisticsSerializer)
    end

    def beginningSoonProjects
      ActiveModel::ArraySerializer.new(object.beginning_soon_projects,
        each_serializer: Api::V2::ProjectStatisticsSerializer)
    end

    def seniorAndroidDevs
      ActiveModel::ArraySerializer.new(object.senior_android_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def seniorIosDevs
      ActiveModel::ArraySerializer.new(object.senior_ios_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def seniorRorDevs
      ActiveModel::ArraySerializer.new(object.senior_ror_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def seniorRorDevs
      ActiveModel::ArraySerializer.new(object.senior_frontend_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def seniorDesigners
      ActiveModel::ArraySerializer.new(object.senior_designers,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def seniorProjectManagers
      ActiveModel::ArraySerializer.new(object.senior_project_managers,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def androidDevs
      ActiveModel::ArraySerializer.new(object.android_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def iosDevs
      ActiveModel::ArraySerializer.new(object.ios_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def rorDevs
      ActiveModel::ArraySerializer.new(object.ror_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def frontendDevs
      ActiveModel::ArraySerializer.new(object.frontend_devs,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def designers
      ActiveModel::ArraySerializer.new(object.designers,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def projectManagers
      ActiveModel::ArraySerializer.new(object.project_managers,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def developersInInternals
      ActiveModel::ArraySerializer.new(object.developers_in_internals,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def interns
      ActiveModel::ArraySerializer.new(object.interns,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def juniorRor
      ActiveModel::ArraySerializer.new(object.junior_ror,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def juniorIos
      ActiveModel::ArraySerializer.new(object.junior_ios,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def juniorAndroid
      ActiveModel::ArraySerializer.new(object.junior_android,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def juniorFrontend
      ActiveModel::ArraySerializer.new(object.junior_frontend,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def juniorProjectManagers
      ActiveModel::ArraySerializer.new(object.junior_project_managers,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end

    def nonBillableInCommercialProjects
      ActiveModel::ArraySerializer.new(object.non_billable_in_commercial_projects,
        each_serializer: Api::V2::UserStatisticsSerializer)
    end
  end
end
