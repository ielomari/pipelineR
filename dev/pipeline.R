batch_size_jenkins <- 3

pipelineR::start_pipeline(
  from = Sys.Date() - 10,
  to = Sys.Date(),
  batch_size = batch_size_jenkins,
  user_login = "ibtissam"
)
message("✅ Pipeline run completed successfully.")
