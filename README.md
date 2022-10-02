# 0913
## 오늘 고민
### 램 및 뷰 구성: 
- 일기 종류에 따라 작성화면과 수정화면을 나눠야하는데 뷰 혹은 뷰 컨트롤러를 만들지 않고 하나를 재활용할 수 있을까?
  - 생각해본 방법: 메인화면에서 일기작성화면으로 넘어갈 때 type자리에 열거형 타입을 넣어서 vc생성을 나눠주기
```
    func foWriteVC(to: MorningAndNight, tasks: MainList) {
        let vc = WriteViewController(type: to)
        vc.data = tasks
        transition(vc, transitionStyle: TransitionStyle.push)
    }
```
-> 그럼 케이스가 늘어날 때마다 새로운 일기작성 인스턴스 상수가 생겨나는 것...? 굳이 그럴 필요가 있을까 
- 하나의 뷰컨으로 이동하고 기능과 뷰를 나눠주는게 더 좋을 것 같다. 
  - 특정 뷰컨으로 이동하는 기능 / 뷰를 갈아주는 기능 / 뷰 안에 기능을 일기종류에 따라(램의 칼럼) 분리
  - 그렇다면 뷰를 아침일기 저녁일기 각각 인스턴스로 만들어서 각 일기별로 수정과 작성을 구현해야할까 / 인스턴스를 만들지 않고 구성을 해야할까 

- 한달일기는 별도의 테이블로 둬서 칼럼을 나눠줘야할 것 같다.

### UI
- [ ] 내 UI크기는 기기너비에 따라 대응하고, 뷰간의 수직간격은 높이에 따라 다시 수정해줘야할 것 같다   
  => 고정되는 뷰를 먼저 그리고 나머지에 동적인 뷰를 채워주는 형식으로 변경 예정

## 💡
- 젭(?) 대 유 잼

# 0914 - 15

## 화면전환구성 
- CalendarViewController > WriteViewController

## 이전 고민지점
- 하나의 뷰컨트롤러로 화면을 여러개 그릴 때 화면의 종류를 뷰컨트롤러에게 어떻게 전달할 것인가
> 1. 0913의 고민지점에서 writeViewController(일기작성 뷰컨, 이하 작성뷰컨)을 인스턴스로 하지 않으려고 했다.  
하지만 어차피 뷰컨의 인스턴스가 생성되도 화면이 캘린더뷰컨으로 전환되면 디이닛이 되기 때문에, 메모리에 계속 남아있지 않아 그냥 아침일기(작성/수정), 저녁일기(작성/수정)  
4개 화면을 enum케이스로 구분하고 인스턴스로 생성하여 화면전환하기로 했다.
<img src="https://user-images.githubusercontent.com/101683386/190527596-bf7cebe1-c0fd-4db3-9a77-9adfa1ccf571.jpg" width="500" height="200">

## 고민했던 부분
- 아침일기와 저녁일기의 작성유무를 어떻게 알 수 있을까? -> 이에 따라 작성과 수정페이지로 이동

### 플레이스 홀더로 구분
- 별로 좋지 않은 방법, 유지보수할 때 다국어지원을하게되거나 플레이스 홀더의 내용을 바꿔줘야한다면 번거롭다 / 사용자가 플레이스 홀더와 같은 내용을 입력하게 된다면 버그발생

### 판단지점의 객체가 nil인지 구분 
- 일기가 있냐 없냐로 구분해야한다면 -> 어차피 램의 객체를 옵셔널로 지정해줬기 때문에, 화면전환하려는 일기종류에 해당하는 일기가 레코드에서 nil이냐로 판단하면 됨

## 트러블슈팅 1
- 코드 의도: 하나의 레코드에서 아침일기와 저녁일기가 관리되고 있는데 어떻게 하나의 레코드를 쪼개서 일기를 구분하고 다시 작성과 수정을 분리할 수 있을까
  
### 이슈 
- 처음에는 새로운 일기 작성이면 새로운 task를 생성해주고, 수정이면 캘린더 뷰컨에서 선택된 날짜로 필터링된 task 값전달로 전달해서 램을 업데이트해줬었다.

<img src="https://user-images.githubusercontent.com/101683386/190528729-e26b3a87-2d4c-46fd-8d8f-b55c68ab3005.jpg" width="350" height="500">

   - 이때 문제는 처음 작성할 때 한 종류의 일기를 작성하면 1.다른 종류의 일기도 같은 내용이 반영된다는 것 2.다른 종류의 일기는 처음 작성해도 무조건 수정화면으로 나온다는 점  

- 그러면 task를 일기종류 별로 따로 생성해주고, 생성할 때 다른 일기종류의 초기화에 nil값을 주면? -> 하나의 레코드에 두 일기가 들어오지 않고 각각생성된다. 

<img src="https://user-images.githubusercontent.com/101683386/190529338-4ba7d5a4-6f83-4de0-973a-9141754f156c.jpg" width="350" height="400">

### 이슈해결
- 해당 날짜에 일기가 있냐 없냐로 구분 

<img src="https://user-images.githubusercontent.com/101683386/190529667-8b0b90b9-d646-416d-951a-4ed06e61490c.jpg" width="500" height="200">

## 고민중인 지점
### 일기종류에 따라 시간을 다르게 반영해줘야함
- 램에 칼럼으로 추가할 수 있지만, 재활용할 가능성이 적어서 반응형으로 만들어볼까 생각중이다.

=> 반응형으로 해도 결국 셀에 날짜별로 저장된 시간을 보여줘야하기 때문에 스키마 수정으로 대응

## 💡
- 램의 객체를 옵셔널로 지정하면 값의 유무를 판한할 때 등 편한 지점이 진짜 많구나
- UI갈아 엎어야할 것 같다.

# 0918 - 코드리뷰

1. 최소버전을 꼭 13부터 하지않아도 됨 15권장
2. 파일과 테이블명은 일치하는게 좋음
3. 접근제어를 걸어서 외부에서 접근하지 못하도록 하기 -> repository
4. 강제해제연산자는 줄이기 -> !try -> do catch / 옵셔널바인딩
  - nil인지 판단해야한다면 guard구문이 좋을 수 있음
5. switch구문이 많은데 꼭 써야하는걸까 합칠 수 없을까?
6. **addItem이 안됐을 때는 사용자도 인지해야함 -> toast나 얼럿을 띄워주기**
7. 불필요한 괄호는 생략 EX. ({}) -> {}
8. **self는 명시적으로 캡쳐가 필요한 상황에서만 써주기 불필요한 리소스낭비 가능성 있음**
9. 해당 뷰컨에 꼭 있어야하는 기능이 아닌데 코드가 길어진다면 extension으로 분리 - 애니메이션은 UIImage + Extension으로 빼줘도 좋음
10. YYYY는 외국 주차는 따르는 경우가 있어서 yyyy를 써주기
11. 리터럴한 문자값은 열거형으로 빼서 휴먼에러를 방지하고 유지보수하기 좋게 변경하기 / 이후 다국어를 생각한다면 다르게 담아보는것도 굳 
12. **모델을 만들었으면 쓰기 -> UserDefaultHelper**
13. **저장버튼을 눌렀을 때 토스트를 띄우고 있는데 그 동안 다른 버튼을 클릭할 수 있음 -> 막던가 토스트를 짧게 띄우던가**
14. cell에서 굳이 재호출되지 않고 고정적으로 쓰이는 기능은 과연 cellForRowAt에서 써주는게 맞는지 생각하기
15. **셀의 높이같은 경우 고정적으로 짧아줌 작은 디바이스에서 얼마나 작아질지 모르기때문 차라리 스크롤을 해주는게 나음**
16 고정적으로 사용하는 부분에 있어 초기화 구문을 사용하여 아예 처음부터 세팅하고 들어가는것도 굳

# 0920
## 노티푸시

### 의도: 계산하지 않고 원하는 시간에 노티푸시를 보낼수있을까?
    요구사항 1. 사용자가 선택한 시간이 저장돼야함
    요구사항 2. 저장한 시간을 불러와야함

### 시도: 
    1. 유저디폴드에 사용자가 선택한 시간을 저장하고 노티피케이션의 Date타입과 맞출 수 없을까? -> 프린트로 찍어봤을 때 다르게 출력돼서 생각한 방법 찾지 못함...
    2. dateComponent로 어떻게 시간 형태를 구성하여 노티로 보낼 수 있을까?
    
### 공식문서를 읽어보니 한방에 hh:mm로 보내지 않고 따로따로 date.hour , date.minute 이렇게 적용해도 알아서 합쳐지면서 전달됨
[공식문서](https://developer.apple.com/documentation/usernotifications/uncalendarnotificationtrigger)
> Declaration
class UNCalendarNotificationTrigger : UNNotificationTrigger
Overview
Create a UNCalendarNotificationTrigger object when you want to schedule the delivery of a local notification at the date and time you specify. You use an NSDateComponents object to specify only the time values that you want the system to use to determine the matching date and time.
Listing 1 creates a trigger that delivers its notification every morning at 8:30. The repeating behavior is achieved by specifying true for the repeats parameter when creating the trigger.
Listing 1 Creating a trigger that repeats at a specific time
```
var date = DateComponents()
date.hour = 8
date.minute = 30 
let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
```

- 위의 공식문서를 참고하여 적용된 쉐도잉 코드....
- 유저디폴트에 array로 데이트컴포넌트를 저장해준 후 이를 빼옴

```
        //MARK: 선택완료버튼 클릭
        let selection = UIAlertAction(title: "선택완료", style: .default) { _ in
            UserDefaults.standard.set(dateStringFormatter.string(from: datePicker.date), forKey: "\(sender.tag)")
            let dateString = UserDefaults.standard.string(forKey: "\(sender.tag)")
            sender.setTitle(dateString, for: .normal)
            print("========>", "\(datePicker.date)")
            
            if sender.tag == 0 {
                var date = DateComponents(timeZone: .current)
                var Marray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
             
                UserDefaults.standard.set(Marray, forKey: "Mdate")
                Marray = UserDefaults.standard.array(forKey: "Mdate") as? [Int] ?? [Int]()
            
                date.hour = Marray[0]
                date.minute = Marray[1]
                
                self.sendNotification(subTitle: "아침일기를 쓰러가볼까요?", date: date)
                
                print("아침 일기 알람 설정 📍")
            } else if sender.tag == 1 {
                var date = DateComponents(timeZone: .current)
                var Narray = [CustomFormatter.changeHourToInt(date: datePicker.date), CustomFormatter.changeMinuteToInt(date: datePicker.date)]
             
                UserDefaults.standard.set(Narray, forKey: "Ndate")
                Narray = UserDefaults.standard.array(forKey: "Ndate") as? [Int] ?? [Int]()
            
                date.hour = Narray[0]
                date.minute = Narray[1]
                
                self.sendNotification(subTitle: "밤일기를 쓰러가볼까요?", date: date)
                print("밤일기 알람 설정 📍")
            }
            
        } 
```

### 걸리는 부분
`UserDefaults.standard.array(forKey: "Ndate") as? [Int] ?? [Int]()`
- 유저디폴트에 값이 없으면 빈 배열를 넣어주고있는데... 예외처리가 필요한가 내일 확인해봐야겠당

## 소회
- 공식문서가 짱이다.
 
---

# 0921
## pop뷰컨 띄우기
### 마지막날에 pop뷰컨 띄우기
1. 달의 첫날 구하기
2. 달의 마지막 날 구하기
- dateComponents를 이용해서 year, month까지 입력하고 day를 입력하지 않으면 달의 첫날을 구할 수 있다.
- byAdding을 통해서 다음달을 구해주고, 그 다음달에서 하루를 빼면 당월의 마지막날이 나온다.
### 활용메서드
`func component(_ component: Calendar.Component, from date: Date) -> Int`
- 위의 코드에서 year, month까지만 입력하면 day는 1로 반영된다.
`calendar?.date(from: components!)!`
- 이를 다시 date로 변환시키는 함수에 넣어주면 달의 첫날을 구할 수 있다.

=> 이런방식으로 components와 date를 변환해서 쓰면 된다.

# 0922
## 탭바 화면전환
- `self.tabBarController?.selectedIndex = 0` 
  - 탭바는 넣을 때부터 배열형태로 넣을 수 있어서 인덱스를 가진다. 그래서 이렇게 화면 전환을 할 수 있음
## 동시간에 노티를 같이 걸었을 때
- 같은 시간에 노트가 요청돼서 마지막 순서의 로컬알림만 올 수 있음
- 비동기처리로 해결

## 백업복구: 코더블(0922 - 0925)
### 백업
- 
### 복구
-

# 0923
- iqkeyboad를 빼고 textView의 뷰를 올리는 방식 채택
  - textView bottom과 contentsInset을 키보드 높이만큼 조정해서 커서가 키보드에 가져지지 않게 만듦

# 0924

## 일기 삭제에 대한 분기처리 해주기

## 검색화면애서 일기를 수정하는 화면으로 이동하고 삭제할 수 있도록 하기
- 스와이프 말고 peekandpop처럼 꾹 누르면 수정과 작성에 대한 메뉴가 뜨게하고 싶었음
- ios13부터 previewingContext(_:commit:) 없어짐 
 -> tableviewDelegate에 있는 아래 메서드 사용함 
 ```func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?```
   -> 🟠 기존에 셀의 contents뷰 내부에 커스텀 뷰의 corneradius를 걸어줬는데, 꾹 누르면 contentsView의 여백이 같이 보여져서 차후 collectionViewcell로 만들기
   
   
# 0926
## 램구조 변경
### 기존에 한 레코드에서 아침일기과 밤일기 2개의 셀이 나오는 구조
- 문제점 1. 분기처리가 어려움(특히 추가 및 삭제)
  - 하나의 레코드이기 때문에 아침일기 컬럼이 밤일기 컬럼에 영향을 주지 않도록 분기처리를 해왔음
  - 추가에 있어 하나의 일기에 대한 레코드가 추가되면 다른 일기는 nil인 상태로 생성됨
  그래서 기존에 일기에 내용이 있는지 및 플레이스홀더와 내용이 같은지로 판단
    - 일기를 작성하면 생성되야하는 로직에 맞지 않을 뿐더러 분기처리가 미흡하면 작성하지 않은 일기를 터치해도 새로 작성하는 화면이 아니라 수정화면으로 넘어갈 수 있는 위험요소가 있음
    - 또한 플레이스홀더의 내용이 바뀌거나 다국어 대응을 할 경우 분기처리가 복잡해지고, 새로작성화면이 아니라 수정화면으로 넘어가는 오류발생가능성이 높음
  - 삭제에 있어 아침일기를 삭제해도 밤일기가 남아있어야하기 때문에 아침일기 컬럼에 nil을 할당해주는 방식으로 처리했었음
    - 해당 일기의 내용삭제가 아니라 일기 자체를 삭제하는 로직인데 nil을 할당하는 것이 맞나라는 의문점
    - 차후 필요없는 레코드가 삭제되지 않고 nil값만 있는 채로 DB에 쌓일 수 있음
    -> 램구조 변경결정
    
### 변경된 램
- 기존 아침일기와 밤일기 컬럼을 type이라는 Int타입으로 묶여주고 셀의 인덱스의 순서와 같게 설정해줌(아침일기 0, 밤일기 1)
  - 새벽일기 등 일기 종류를 추가할 때도 좋음 -> 연결관계가 분리된 것
  - 아침일기시간 밤일기 시간 컬럼도 time으로 묶음
- 날짜에 있어서 기존에 filter하면 하나의 레코드를 받아왔었는데 2개의 레코드를 받아와서 원하는 곳에 적용하는 형태로 바뀜

# 0927
## 로컬푸시 ID바꾸기
- Date()로 로컬 푸시를 identifier를 설정해주고 있었는데, 같은 내용으로 같은 시간에 보내주고 있기 때문에 노티를 갈아주는 형식으로 변경

# 0928
## 삭제
- 삭제할 데이터가 없는데 삭제버튼을 눌렀을 때
  - 새작성화면 - 비활성화
  - 수정 - 토스트

# 0929
## 일기를 새로 작성하는 뷰컨 이슈
- 처음에는 viewWillDisappear에 걸어줬다가 새로 작성하는 화면에서는 작성뷰컨에서 홈화면으로 이동하려는 스와이프 동작을
화면을 터치한 상태로 반복하면 레코드가 계속 추가됐음
- viewDidDisappear에 넣어주면 탭바 이동시에 레코드가 계속 추가됨
  - 탭바를 없앨 수 있지만 사용성이 떨어짐 
- 저장버튼을 따로 만들어주고 버튼을 눌렀을 때 저장할 수 있게 변경
  - 저장되면 바로 pop되게 변경
- 완료버튼을 저장버튼으로 하고 툴바 생성해서 textView가 firstResponder가 됐을 때 보이는 뷰(inputAccessoryView)에 추가해 키보드를 내릴 수 있도록함
  ```
  func textViewDoneBtnMake(text_field : UITextView) {
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        ViewForDoneButtonOnKeyboard.items = [flexibleSpace, btnDoneOnKeyboard]
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    ```

- 삭제를 누르고 플레이스홀더를 편집할 수 있는 버그 수정
  - 삭제버튼을 누르면 textView에 resignResponder해줌
