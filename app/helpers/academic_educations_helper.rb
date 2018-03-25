module AcademicEducationsHelper
  def academic_educations_levels_for_select
    AcademicEducation.levels.map do |k, v|
      [ I18n.t("activerecord.attributes.academic_education.levels.#{k}", k) ]
    end
  end
end
