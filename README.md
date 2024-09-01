# PhotosClone

## 개발 환경 및 프레임워크
|구분|항목|
|:---:|---|
|**Environment**|iOS 16.0+, Xcode 15.3|
|**Language**|Swift|
|**UI**|UIKit, Codebase AutoLayout|
|**Framework**|Photos, CoreLocation, AVFoundation, Swift Concurrency|

## Development 
### 구현한 기능 
Photos 앱은  <보관함, For You, 앨범, 검색> 총 네 개의 탭을 가지고 있습니다. 이 중 보관함과 For You 탭을 구현하였습니다. 

#### 1. 보관함
- "모든 사진"
    - PinchGesture를 통해 사진 축소 / 확대 기능, 동적으로 cell 크기 변경 기능 구현
    - 해당 사진을 탭하면 FullScreenViewController로 이동 
    
- "일" / "월" / "연"
    - 기기에 저장되어 있는 모든 사진을 일자별 / 월별 / 연별로 Sorting하여 출력  
    - `fetchDateRange()` 메서드를 통해 DateType (.day, .month, .year)에 따른 각 시작 날짜와 종료 날짜 반환 
    - `fetchRangeDateAssets(for:)` 메서드에서 DateMode별 [PHAsset] 타입으로 asset 정보 반환 

#### 2. For You 
- CompositionalLayout을 사용하여 총 세 개의 Vertical Section, 각 섹션은 Horizontal Group으로 구성되도록 구현 
- HeaderView의 경우 공통 HeaderView를 구현하여 재사용
- 해당 사진을 찍은 장소 및 날짜 호출 
- 동영상 앨범의 경우, 동영상 재생 기능 구현 (탭하는 경우 isPlaying 상태 토글)

#### 3. AutoLayout의 효율적인 사용을 위한 UIView Extension 구현
AutoLayout을 코드로 구현할 때 반복되는 코드를 줄이고자 UIView Extension을 구현하였습니다. 

- `translateAutoresizingMaskIntoConstraints = false` 부분이 여러차례 호출되는 문제를 해결하고자 하위뷰를 addSubview 할 때 한 번만 호출 될 수 있도록 구현하였습니다. 

    ```swift
    func addAutoLayoutSubview(_ subview: UIView) {
        subview.setupForAutoLayout()
        self.addSubview(subview)
    }
    
    func setupForAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    ```



## ScreenShots 
|AllPhotosView|dayPhotosView|monthPhotosView|yearPhotosView|RecommendViewController|FullScreenViewController|
|:---:|:---:|:---:|:---:|:---:|:---:|
|<img src="https://github.com/user-attachments/assets/87f3e068-8d6b-45dc-88c1-544ede75c33e" width="190">|<img src="https://github.com/user-attachments/assets/185a84d9-651c-41fa-bb9f-aa722ee20568" width="190">|<img src="https://github.com/user-attachments/assets/8f92eaba-2dcb-4945-a68b-6db722e6cebe" width="190">|<img src = "https://github.com/user-attachments/assets/22b5ee85-c541-47cb-90a6-7e4cedd5f4f5" width="190">|<img src="https://github.com/user-attachments/assets/6d374c2b-0dff-4185-ab6f-e6c48d04f170" width="190">|<img src="https://github.com/user-attachments/assets/297dff91-3143-43bb-b162-fbcc2e5356fa" width="190">|



## 테스트 
- iOS 16.0 이상이 설치되어 있는 iPhone 혹은 시뮬레이터에서 테스트 가능합니다.
