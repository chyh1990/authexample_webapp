/// @file mask_processor.cpp  @version 1.0 @date 07/12/2013
/// @author BlahGeek@Gmail.com

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <cstdlib>
#include <string>
#include <cassert>

using namespace std;
using namespace cv;


int main ( int argc, char *argv[] )
{
    Mat orig = imread(argv[1], 1);
    Mat mask = imread(argv[2], 0); // grayscale
    assert(orig.size() == mask.size());

    Mat bg(orig.size(), CV_8UC4);
    Mat fg(orig.size(), CV_8UC4);

    for(int row = 0 ; row < orig.rows ; row += 1)
        for(int col = 0 ; col < orig.cols ; col += 1){
            if(mask.at<char>(row, col) == 0){
                fg.at<Vec4b>(row, col)[3] = 0;
                for(int i = 0 ; i < 3 ; i += 1)
                    bg.at<Vec4b>(row, col)[i] = orig.at<Vec3b>(row, col)[i];
                bg.at<Vec4b>(row, col)[3] = 255;
            }
            else{
                bg.at<Vec4b>(row, col)[3] = 0;
                for(int i = 0 ; i < 3 ; i += 1)
                    fg.at<Vec4b>(row, col)[i] = orig.at<Vec3b>(row, col)[i];
                fg.at<Vec4b>(row, col)[3] = 255;
            }
        }

    imwrite(argv[3], bg);
    imwrite(argv[4], fg);
    return EXIT_SUCCESS;
}
