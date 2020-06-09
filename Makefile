DC_RUN_FLAGS=--rm
DOCKER_COMPOSE ?= docker-compose
AWS_PROFILE ?= 'default'
USERNAME ?= ''

lint:
	$(DOCKER_COMPOSE) run $(DC_RUN_FLAGS) aikr black -t py38 -l 120 .

rotate:
	$(DOCKER_COMPOSE) run $(DC_RUN_FLAGS) \
	    -e AWS_PROFILE=$(AWS_PROFILE) \
        aikr python3 aws_iam_key_rotator.py -u $(USERNAME)
