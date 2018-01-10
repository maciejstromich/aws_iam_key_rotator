DC_RUN_FLAGS=--rm
DOCKER_COMPOSE ?= docker-compose
AWS_PROFILE ?= 'default'
USERNAME ?= ''

lint:
	$(DOCKER_COMPOSE) run $(DC_RUN_FLAGS) aikr flake8 --exclude=.git,__pycache__,.eggs,*.egg,__init__.py, \
		--max-line-length=120 .

rotate:
	$(DOCKER_COMPOSE) run $(DC_RUN_FLAGS) \
	    -e AWS_PROFILE=$(AWS_PROFILE) \
        aikr python3 aws_iam_key_rotator.py -u $(USERNAME)