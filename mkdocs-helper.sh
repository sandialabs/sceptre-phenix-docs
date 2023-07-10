#!/bin/bash

which docker &> /dev/null

if (( $? )); then
  echo "Docker must be installed (and in your PATH) to use this build script. Exiting."
  exit 1
fi


USER_UID=$(id -u)
USERNAME=builder


docker build -t mike -f - . <<EOF
FROM squidfunk/mkdocs-material

RUN addgroup --gid $USER_UID $USERNAME \
  && adduser -s /bin/sh --uid $USER_UID --ingroup $USERNAME -D -H $USERNAME

RUN git clone https://github.com/jimporter/mike.git /tmp/mike \
  && python3 -m pip install /tmp/mike

ENTRYPOINT ["mike"]

CMD ["serve", "--dev-addr=0.0.0.0:8000"]
EOF

docker run -it --rm --net host -v ${PWD}:/docs -w /docs -u ${USERNAME} mike "$@"
