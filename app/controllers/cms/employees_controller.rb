class Cms::EmployeesController < Cms::ApplicationController
  def index
    @employees = Employee.all
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
