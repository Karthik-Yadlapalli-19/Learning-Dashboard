enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case failed(AppError)
}
