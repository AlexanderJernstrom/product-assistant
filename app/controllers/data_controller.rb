require "csv"
class DataController < ApplicationController
  def index
    @company_id = params[:company_id]
    @product_uploads = Company.find(@company_id).product_uploads.order(created_at: :desc)
  end

  def create
    company_id = params[:company_id]
    file = params[:file]

    csv_file = File.read(file.tempfile.path)
    products = CSV.parse(csv_file, headers: true).map(&:to_h).reject { |hash| hash.values.include?(nil) }
    products = products.take 50


    job = ProductUpload.create(company_id: company_id, status: "Running")
    upload_job = UploadProductDataJob.perform_now(products, company_id, job)
    job.update(job_id: upload_job.job_id)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.append(
          "upload-container",
          partial: "data/upload_status",
          locals: { job: job }
        )]
      end
    end
  end
end
