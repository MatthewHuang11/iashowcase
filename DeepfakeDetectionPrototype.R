#eventually find way to suppress messages
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

# Loading the model (through github)
model_url <- "https://github.com/MatthewHuang11/iashowcase/raw/main/model1_18epochs_valacc0.9252.hdf5"
temp_file <- tempfile()
download.file(model_url, destfile = temp_file, mode = "wb")
model_path <- temp_file
model <- load_model_hdf5(model_path)

# Define a function to process the image
preprocess_image <- function(image_path, target_size) {
  image <- image_load(image_path, target_size = target_size)
  image <- image_to_array(image)
  image <- array_reshape(image, c(1, dim(image)))
  image <- imagenet_preprocess_input(image)
  return(image)
}

# Make a prediction on an image
predict_image <- function(model, image_path, target_size) {
  image <- preprocess_image(image_path, target_size)
  prediction <- predict(model, image)
  class_indices <- ifelse(prediction < 0.5, "Signs Deepfake Detected - Proceed with Caution!", "Image is Likely Real")
  return(list(class_indices = class_indices, prediction = prediction))
}

# Add Border (based on prediction)
image_border_color <- function(image, prediction, size) {
  if (prediction < 0.5) {
    border_color <- "red"
  } else {
    border_color <- "green"
  }
  image <- image_scale(image, size)
  image_border(image, border_color, "15x15")
}

# Deepfake Detecting User Interface
deepfake_detector <- function() {
  size <- "500x500"
  while (TRUE) {
    cat("\014")
    cat("Welcome to the Deepfake Detector.\n\n")
    cat("Please select an image to test.\n")
    Sys.sleep(2)
    image_path <- file.choose()
    prediction_result <- predict_image(model, image_path, target_size = c(256, 256))
    class_indices <- prediction_result$class_indices
    prediction <- prediction_result$prediction
    cat("\014")
    cat("Processing Image...")
    Sys.sleep(2)
    displayimage <- image_read(image_path)
    displayimage <- image_border_color(displayimage, prediction, size)
    print(displayimage)
    cat("\014")
    print(class_indices)
    rerun <- readline(prompt = "Do you want to test another image? (y/n) ")
    if (tolower(rerun) != "y") {
      cat("\nThank you for using the Deepfake Detector.")
      return(invisible())
    }
  }
}
deepfake_detector()
