prebuild:
ifndef image
	$(error image is undefined)
endif
	$(info "Image: ${image}")
	docker build \
	-t ${image} \
	-f docker/prebuild/Dockerfile .

build:
ifndef image
	$(error image is undefined)
endif
ifndef base_image
	$(error base_image is undefined)
endif
	$(info Image: ${image})
	$(info Base Image: ${base_image})
	docker build \
	-t ${image} \
	--build-arg BASE_IMAGE=${base_image} \
	-f docker/release/Dockerfile .
