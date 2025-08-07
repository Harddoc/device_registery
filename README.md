# Device Registry

Thank you for taking the time to review my code!

This is a simple device registration system built with Ruby on Rails. It allows users to register devices and return them and ensures proper ownership tracking through assignment history.

---

## Getting Started

To run this project locally, Docker is highly recommended for simplicity and consistency across environments.

### Prerequisites

- [Docker](https://www.docker.com/) installed on your system.

---

##  Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/Harddoc/device_registery.git
   cd device_registery
    ```

2. **Build the Docker image**

   ```bash
   docker build -t device-registry .
   ```

  ### !!! important: 
  If running a Windows machine aditional command may be required!!!

  It will convert the files to use Unix-style line endings.
   ```bash
   dos2unix bin/*
   ```
3. **Run the Docker container**

   ```bash
   docker run -d -p 3000:3000 device-registry
   ```
4. **Check running containers**

   ```bash
   docker ps
   ```
   Note the container name, e.g., `elegant_morse`.
5. **Run the Docker container**

   ```bash
   docker exec -it elegant_morse sh
   ```
## Running Tests
Inside the container shell, run the following command:

   ```bash
   bundle exec rspec
   ```
## Notes
Custom errors are defined under `lib/errors/` and registered in `application.rb`.

The migrations should be taken care of by Docker.

By default, this setup is test-ready. To run in production mode, additional configuration may be required. See dockerfile!

## Author
@Harddoc

Thank you for the opportunity!

