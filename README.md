# RequestManager 

# The RequestManager framework provides a simple and flexible way to make network requests and handle responses in Swift. It supports fetching data that conforms to the Decodable protocol as well as handling requests where no response data is expected.

# Usage

#    fetchData<T: Decodable>(from request: URLRequest) -> AnyPublisher<T, Error>

     Fetches data from the given request and decodes it into the specified Decodable type.

#    fetchNoDataResponse(from request: URLRequest) -> AnyPublisher<Void, Error>

   Makes a network request and handles the response where no data is expected.
