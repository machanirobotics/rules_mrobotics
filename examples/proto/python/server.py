import grpc
import logging
from concurrent import futures
from proto import greeter_pb2_grpc, greeter_pb2, thing_pb2

class GreeterServicer(greeter_pb2_grpc.GreeterServicer):
    def SayHello(self, request, context):
        return greeter_pb2.HelloReply(
            message="hello from greeter servicer",
            payload=None,
            thing=thing_pb2.Thing(
                name=request.name,
                payload=None
            )
        )

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    greeter_pb2_grpc.add_GreeterServicer_to_server(GreeterServicer(), server)
    addr = "localhost:8000"
    server.add_insecure_port(addr)
    server.start()
    print(f"started server at {addr}")
    server.wait_for_termination()

if __name__ == "__main__":
    logging.basicConfig()
    serve()
