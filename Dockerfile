FROM ubuntu:20.04

# Install packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    sudo nano htop tree git curl wget zsh

# Set the default shell to zsh
RUN chsh -s $(which zsh)

# Create user and add sudo privlages
RUN  useradd moby && echo "moby:pw" | chpasswd && adduser moby sudo
USER moby
WORKDIR /home/moby

# Install Oh-My-Zsh
RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="fletcherm"/g' .zshrc

# Install and configure anaconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
RUN echo "source /home/moby/miniconda3/bin/activate" >> .zshrc

# Get environment.yml
RUN git clone https://github.com/JaaLynch/moby.git

# Conda environment
RUN /home/moby/miniconda3/condabin/conda env create -f /home/moby/moby/environment.yml
RUN echo "conda activate env" >> .zshrc

# Configure Git
RUN echo "git config --global user.name 'jaalynch'" >> .zshrc
RUN echo "git config --global user.email 'jaalynch@gmail.com'" >> .zshrc

# Expose a port for jupyter notebook
EXPOSE 8888

CMD zsh