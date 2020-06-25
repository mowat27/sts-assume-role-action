# See https://tech.davis-hansson.com/p/make/ for a write-up of these settings

# Use bash and set strict execution mode
SHELL:=bash
.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DOCKER_BUILD_SENTINAL := .last-build.sentinal

.PHONY: clean

build: $(DOCKER_BUILD_SENTINAL)
$(DOCKER_BUILD_SENTINAL): Dockerfile *.sh
	@docker build -t sts-assume-role-action:dev .
	@touch $(DOCKER_BUILD_SENTINAL)

run: build
	@docker run --rm -t \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e AWS_DEFAULT_REGION \
		-e AWS_ASSUME_ROLE_ARN \
		mowat27/sts-assume-role-action:dev

clean: 
	rm -f $(DOCKER_BUILD_SENTINAL)




