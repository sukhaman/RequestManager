# Request Manager

Usage
1. Fetching Data (Decodable)

The fetchData method allows you to make a network request and decode the response into a specified Decodable type.

2. Fetching No Data Response

The fetchNoDataResponse method is used when you expect no data in the response. It ensures the request completes without attempting to decode any response data.

# RequestManager Framework

# The RequestManager framework provides a simple and flexible way to make network requests and handle responses in Swift. It supports fetching data that conforms to the Decodable protocol as well as handling requests where no response data is expected.

# Usage

#    fetchData<T: Decodable>(from request: URLRequest) -> AnyPublisher<T, Error>

     Fetches data from the given request and decodes it into the specified Decodable type.

#    fetchNoDataResponse(from request: URLRequest) -> AnyPublisher<Void, Error>

   Makes a network request and handles the response where no data is expected.
