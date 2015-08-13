class AffiliationsController < ApplicationController
  def new
    @affiliation = Affiliation.new
    @affiliation.person = Person.find(params[:person_id])
  end

  def create
    country = Country.where(name: params[:country]).first
    if country.nil?
      country = Country.create(name: params[:country])
    end
    institution = Institution.where(name: params[:institution]).where(country_id: country.id).first
    if institution.nil?
      institution = Institution.create(name: params[:institution],country_id: country.id)
    end
    department = Department.where(name: params[:department]).where(institution_id: institution.id).first
    if department.nil?
      department = Department.create(name: params[:department],institution_id: institution.id)
    end
    person = Person.find(params[:person_id])
    affiliation = Affiliation.new(affiliation_params)
    affiliation.person = person
    affiliation.department = department
    affiliation.save
    redirect_to person
  end

  def destroy
    affiliation = Affiliation.find(params[:id])
    affiliation.destroy
    redirect_to affiliation.person
  end

  private
  def affiliation_params
    params.require(:affiliation).permit(:year_from,:year_to)
  end
end
