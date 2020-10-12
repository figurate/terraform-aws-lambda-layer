from diagrams import Diagram
from diagrams.aws.compute import Lambda

with Diagram("AWS Lambda Layer", show=False, direction="TB"):

    Lambda("lambda layer")
