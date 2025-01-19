from setuptools import setup, find_packages

setup(
    name="psychrometry",                  # Name of the library
    version="1.0.0",                      # Version
    description="A library for psychrometric calculations.",
    author="Aditya Varma",                   # Your name
    author_email="adityavarma2106.pwap@gmail.com",# Your email
    packages=find_packages(),             # Automatically finds Python modules in the folder
    install_requires=['numpy','scipy>=1.5.0','matplotlib'],                  # List any dependencies, e.g., ['numpy']
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',              # Minimum Python version
)