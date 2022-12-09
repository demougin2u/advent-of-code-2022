.PHONY: build help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

day1: ## Run Day1
	node 01/index.js
day2: ## Run Day2
	node 02/index.js
day3: ## Run Day3
	node 03/index.js
day4: ## Run Day4
	node 04/index.js
day5: ## Run Day5
	node 05/index.js
day6: ## Run Day6
	node 06/index.js
day7: ## Run Day7
	dart 07/index.dart
day8: ## Run Day8
	node 08/index.js
day9: ## Run Day9
	dart 09/index.dart
