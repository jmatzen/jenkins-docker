FROM jenkins/jenkins:lts

USER root

# Install dependencies required for Rust and Cargo
RUN apt-get update && apt-get install -y curl build-essential git


# Create the custom directory for Cargo
RUN mkdir /var/cargo && chown jenkins:jenkins /var/cargo


USER jenkins


# Set the environment variables for Cargo and rustup
ENV CARGO_HOME=/var/cargo
ENV RUSTUP_HOME=/var/cargo/rustup
ENV PATH="${CARGO_HOME}/bin:${PATH}"

# Switch to the Jenkins user
USER jenkins

# Install Rust and Cargo with rustup for the Jenkins user
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

USER root
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN brew tap cargo-lambda/cargo-lambda && brew install cargo-lambda

# Switch back to the Jenkins user context
USER jenkins
