require 'fileutils'
require 'securerandom'

class Api::V1::FileController < ApplicationController
    skip_before_filter :verify_authenticity_token,
        :if => Proc.new { |c| c.request.format == 'multipart/form-data' }

    before_filter :authenticate_user!

    respond_to :json

    def uploadfile
        basename = SecureRandom.uuid
        [:image, :mask].each do |i|
            if params[i].blank?
                badrequest "#{i.to_s} is needed"
                return
            end
            if params[i].content_type != 'image/png'
                badrequest "Type of image and mask must be png"
                return
            end
            tmp = params[i].tempfile
            file = File.join('public', 'photos', "#{basename}.#{i.to_s}.png")
            FileUtils.cp tmp.path, file
        end
        unless system "cd public/photos && " + 
            "../../mask_processor #{basename}.image.png #{basename}.mask.png #{basename}.bg.png #{basename}.fg.png"
            badrequest 'Mask processor error'
            return
        end
        photo = Photo.new(:desc => params[:desc], :tag => params[:tag], :uuid => basename, :user => current_user)
        photo.tag_list = params[:tag]
        photo.save
        render :status => 200, :json => {:success => true, :uuid => basename}
    end

    def listfile
        photos = Photo.scoped
        unless params['tag'].blank?
            photos = photos.tagged_with(params['tag'])
        end
        photos = photos.offset(params.fetch(:offset, 0)).limit(params.fetch(:limit, 20))
        render :status => 200, :json => photos.to_json
    end

    def badrequest(msg)
        render :status => 400, :json => {:success => false, :error => msg}
    end

end
