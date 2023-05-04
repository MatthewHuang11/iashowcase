install.packages('tensorflow')
library(tensorflow)
install.packages('magick')
library(magick)
install.packages('keras')
library(keras)
install_tensorflow()
install.packages("devtools")
library(devtools)
cat("\014")

# Loading the model
model_path <- "/Users/matthew_h/Downloads/model2_17epochs_valacc0.89.hdf5"
model <- load_model_hdf5(model_path)

# Define a function to process the image
preprocess_image <- function(image_path, target_size) {
  image <- image_load(image_path, target_size = target_size)
  image <- image_to_array(image)
  image <- array_reshape(image, c(1, dim(image)))
  image <- imagenet_preprocess_input(image)
  return(image)
}

# Function to make a prediction on an image
predict_image <- function(model, image_path, target_size) {
  image <- preprocess_image(image_path, target_size)
  prediction <- predict(model, image)
  class_indices <- ifelse(prediction < 0.5, "Image is Likely Real", " Signs Deepfake Detected - Proceed with Caution!")
  return(class_indices)
}

#Deepfake Detecting User Interface - In Progress
deepfake_detector <- function() {
  while (TRUE) {
    cat("\014")
    cat("Welcome to the Deepfake Detector.\n\n")
    cat("Please select an image to test.\n")
    Sys.sleep(2)
    image_path <- file.choose()
    prediction <- predict_image(model, image_path, target_size = c(256, 256))
    cat("\014")
    cat("Processing Image...")
    Sys.sleep(2)
    cat("\014")
    Sys.sleep(1.5)
    print(prediction)
    rerun <- readline(prompt = "Do you want to test another image? (y/n) ")
    if (tolower(rerun) != "y") {
      cat("\nThank you for using the Deepfake Detector.")
      return(invisible())
    }
  }
}


deepfake_detector()



