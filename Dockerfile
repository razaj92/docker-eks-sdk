FROM docker:18.06.1-ce-dind

ENV HELM_VERSION              v2.14.1
ENV HELMFILE_VERSION          v0.79.3
ENV IAM_AUTHENTICATOR_VERSION 1.12.7
ENV KUBECTL_VERSION           v1.13.4
ENV LINKERD2_VERSION					stable-2.3.2

ENV AWS_DEFAULT_REGION eu-west-1

ADD https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/${IAM_AUTHENTICATOR_VERSION}/2019-03-27/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
ADD https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 /usr/local/bin/helmfile
ADD https://github.com/linkerd/linkerd2/releases/download/${LINKERD2_VERSION}/linkerd2-cli-${LINKERD2_VERSION}-linux /usr/local/bin/linkerd

RUN \
chmod +x /usr/local/bin/kubectl \
&& chmod +x /usr/local/bin/helmfile \
&& chmod +x /usr/local/bin/aws-iam-authenticator \
&& chmod +x /usr/local/bin/linkerd \
&& apk --no-cache add git curl ca-certificates openssl bash gettext jq py-pip \
&& curl -sSL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz \
&& mv linux-amd64/helm /usr/local/bin/helm \
&& rm -rf linux-amd64 \
&& helm init -c \
&& helm repo remove local \
&& pip install -I --upgrade awscli pip \
&& helm plugin install https://github.com/databus23/helm-diff \
&& mkdir ~/.kube ~/.aws

VOLUME ["~/.kube"]

ENTRYPOINT []
