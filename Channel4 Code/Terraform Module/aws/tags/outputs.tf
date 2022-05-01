output "tags" {
  value = merge(
    var.default_tags,
    {
      "ReviewDate" = element(split("T", timestamp()), 0)
    },
  )
}

