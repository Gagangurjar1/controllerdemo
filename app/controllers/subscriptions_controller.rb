class SubscriptionsController < ApplicationController
  before_action :set_course
  
  def create
    if params[:user_type] == 'student' && params[:user_id]
      student = User.find_by(id: params[:user_id], user_type: 'student')
      course = @course
  
      unless student.nil?
        if student.subscribed_to?(course)
          render json: { error: 'Student is already subscribed to this course.' }
        else
          subscription = Subscription.new(user: student, course: course)
          if subscription.save
            render json: { message: 'Course subscribed successfully.' }
          else
            render json: { error: 'Failed to subscribe to the course.' }
          end
        end
      else
        render json: { error: 'Student not found.' }, status: :not_found
      end
    else
      render json: { error: 'Invalid parameters.' }, status: :unprocessable_entity
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end

def create
  if teacher? 
    @course = Course.new(course_params)
  
    if @course.save
    render json: @course, status: :created
    else
    render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  else
    render_teacher_error
  end
end

def teacher?
  user = User.find_by(id: course_params[:user_id].to_i, user_type: course_params[:user_type])
  user.present? && user.user_type == 'teacher'
  end