# Rick and Morty API Client
### 소개
릭앤모티를 활용한 API가 있어서 만들게 됨

### 사용한 라이브러리
- RxSwift: MVVM 아키텍처에서 completion block -> Observable로 인한 가독성 증가 및 다양한 Operator 제공
- RxDataSource: CollectionView DatsSource animate 이펙트와 datasource update sugar
- SnapKit: Constraints Sugar
### 사용한 아키텍처
MVVM input / output
ReactorKit으로 리팩토링 공부 예정
### 구현 기능
HTTP Client와 NetworkLayer 분리
protocol을 활용한 Composable struct
DI활용하기

