# Add tags to append to the tags map below and as a separate output
output "tags" {
  value = merge(var.tags)
}

output "review_date" {
  value = format(
    "%d-%s-%s",
    element(split("-", element(split("T", timestamp()), 0)), 0) + 1,
    element(split("-", element(split("T", timestamp()), 0)), 1),
    element(split("-", element(split("T", timestamp()), 0)), 2),
  )
}

