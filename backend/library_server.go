package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/go-chi/chi"
	_ "github.com/go-sql-driver/mysql"
)

type othersfrom_db struct{
  BookId int;
  BookAuthor string;
  singlebookname string;
// IssuedTime string;
//   ExpiryTime string;
}

type almostall struct{
  BookId int;
IssuedTime string;
  ExpiryTime string;
  //available_or_not bool;
}
type value struct{
  BookName []string;

}

type BOOKID struct{
  BookId int;
}

type fines struct{
  fine int;
  issued_time []byte;
  expiry_time []byte;
  book_name string;
  book_author string;
  
}
type erro struct{
  errors string;
}
func postbookid(db *sql.DB, w http.ResponseWriter, r *http.Request){
var bookid BOOKID;
fmt.Print("bhayo1 \n\n\n\n\n");
res:=io.NopCloser(r.Body);
fmt.Print("bhayo2 \n\n\n\n\n");
resbyte,_:=io.ReadAll(res);
fmt.Print("bhayo3 \n\n\n\n\n");

json.Unmarshal(resbyte,&bookid);
fmt.Print(bookid.BookId);
fmt.Print(bookid.BookId);
//var ISSUED_TIME,EXP_TIME time.Time;
 query:="select  fine,issued_time,expiry_time,book_name,book_author from books_info where book_id=? AND expiry_time is not null; ";
 rows,_:=db.Query(query,bookid.BookId);

for rows.Next(){
  print("helo hello hello world ");
  var finevar fines;
rows.Scan(&finevar.fine,&finevar.issued_time,&finevar.expiry_time,&finevar.book_name,&finevar.book_author); 


//&finevar.issued_time,&finevar.expiry_time


strexpirytime:=string(finevar.expiry_time);
fmt.Print(strexpirytime);
expiryhour,_:=strconv.Atoi(strings.Split(strexpirytime, ":")[0]); //
expiryminute,_:=strconv.Atoi(strings.Split(strexpirytime, ":")[1]);

wholetime:=time.Now();

currenthour:=wholetime.Hour(); //
currentminute:=wholetime.Minute(); //
 //iry

fmt.Print(expiryhour,"\n\n");
fmt.Print(expiryminute,"\n\n");
fmt.Print(currenthour,"\n\n");
fmt.Print(currentminute,"\n\n");

// currenthour,currentminute:=wholetime.Hour(), wholetime.Minute();




if expiryhour>currenthour{
  finevar.fine=0;
}else{
  minutes:=(currenthour-expiryhour)*60+currentminute-expiryminute;
  if minutes<0{
    finevar.fine=0;
  }else{
    finevar.fine=minutes*5;
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
    fmt.Print(finevar.fine);
  }
}
fmt.Print("\n\n\n",finevar.fine);
stb,_:=db.Prepare("UPDATE books_info SET fine=? WHERE book_id=?;");

stb.Exec(finevar.fine, bookid.BookId);





finevarmap:=map[string]interface{}{
  // fine int;
  // issued_time string;
  // expiry_time string;
  // book_name string;
  // book_author string;
  "fine": finevar.fine,
  "issued_time": string(finevar.issued_time),
  "expiry_time": string(finevar.expiry_time),
  "book_name":finevar.book_name,
  "book_author":finevar.book_author,
}
finevarJSON,_:=json.Marshal(finevarmap);
w.Write([]byte(finevarJSON));

}
}



func get_others_to_flutter(db *sql.DB,w http.ResponseWriter, _ *http.Request)(map[string]othersfrom_db){
  
  rows,err:=db.Query("select  book_id,book_name,book_author from books_info;");//!does this query work after all statements of db has been executed or what  ? 

  if err!=nil{
    panic(err);
  }
  
  defer rows.Close();
  count:=0;
 // forflutter.BookName=make([]string, 20);//!why required not getting the concept.
             
  
          var dummyslice = []othersfrom_db{};   
  for rows.Next(){
    var bookid int;
    var bookname string;
    var bookauthor string;
     //!missiing issued date wala kura.

    err:= rows.Scan(&bookid,&bookname,&bookauthor);
    if err!=nil{
      fmt.Print("sorry scan for rows ma gadbad ahecha");
      }else{
       dummyslice=append(dummyslice,othersfrom_db{BookId: bookid,singlebookname: bookname,BookAuthor: bookauthor,});
       
      }
      count=count+1;
      
    }
    mapforflutter :=make(map[string]othersfrom_db);
    for  i:=0;i<count;i++{
      ind:=fmt.Sprintf("%d",i);
         
    
   mapforflutter[ind]=dummyslice[i];
  
  }


   

   
return mapforflutter;
}

func post_others_to_flutter(db *sql.DB,w http.ResponseWriter, r *http.Request) {
  //!this function will be called when the flutter app is opened.
  var bookname string;
  fmt.Print("hello from inside\n\n\n")
  response:=io.NopCloser(r.Body);
  responsestring,err:=io.ReadAll(response);
 
  json.Unmarshal(responsestring,&bookname);
  fmt.Print(bookname);
  fmt.Print("hello from inside 222")

  if err!=nil{
    panic(err);
  }else{
    fmt.Print(string(responsestring));
    
    mapforflutte:=get_others_to_flutter(db,w,r);

    for _,val:= range mapforflutte{    
      
      if (val.singlebookname ==bookname){
       
        validstruct,_:=json.Marshal(val);
  w.Write(validstruct);
  return;
 }
    
  }
  errorstruct,_:=json.Marshal(othersfrom_db{});
  w.Write([]byte(errorstruct));

  
  
}};





func get_db_book_to_flutter(db *sql.DB,w http.ResponseWriter, _ *http.Request,forflutter *value){
  //!written becz i need this for search recommendation separated as less time ma nai chahieko cha. mathi ko aru kura le extra time khana sakcha so separately execute garchu in init state.
  
  rows,err:=db.Query("select  book_name from books_info;");
  if err!=nil{
    panic(err);
  }
  //i:=0;


  defer rows.Close();
  count:=0;
 // forflutter.BookName=make([]string, 20);//!why required not getting the concept.
              var dummyslice []string;
            var dummystrings string;
  for rows.Next(){

    err:= rows.Scan(&dummystrings);
    if err!=nil{
      fmt.Print("sorry scan for rows ma gadbad ahecha");
      }else{
        dummyslice = append(dummyslice,dummystrings);
       

      }
      count=count+1;

    }

    data,err:=json.Marshal(dummyslice);


    w.Write(data);
}

// !func get_db_names()


//?func to /posttime

func posttimes(db *sql.DB,w http.ResponseWriter, r *http.Request){

var toupdate almostall;

response:=io.NopCloser(r.Body);
responsestring,_:=io.ReadAll(response);
json.Unmarshal(responsestring,&toupdate);


stmt,err:=db.Prepare("UPDATE books_info SET issued_time=? ,expiry_time=? ,available_or_not =false where book_id=?;");
fmt.Print("completeed\n\n\n")
if (err != nil){
  fmt.Print("error in update command in prepare statement");
}
_,err=stmt.Exec(toupdate.IssuedTime,toupdate.ExpiryTime, toupdate.BookId);
if err!=nil{
  print("wrong bhato wrong bhayo while exec\n\n\n\n")
}
fmt.Print(toupdate.BookId);
fmt.Print(toupdate.ExpiryTime);
fmt.Print("bhayo ")
fmt.Print(toupdate.IssuedTime);
if(err != nil){
fmt.Print("wrong in snitization process");
}

}
func main(){
  router:=chi.NewRouter();
	db_username:=os.Getenv("DB_USERNAME");
	db_password:=os.Getenv("DB_PASSWORD");

	db_port:=os.Getenv("DB_PORT");
	db_name:=os.Getenv("DB_NAME");
  db_datasource:=fmt.Sprintf("%s:%s@tcp(localhost:%s)/%s?parseTime=true",db_username,db_password,db_port,db_name);
  db,err:=sql.Open("mysql",db_datasource);
  if err!=nil{
	fmt.Print("error mysql ma ")
}
defer db.Close(); //!why?
var forflutter  value;

//?===-=-===-===-===-===-===-===-===-===-===-===-===-=-=-=-=-=-=-=-================
//!POST /Postbookid
router.Post("/postbookid",func(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Access-Control-Allow-Origin", "*");
  w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        w.Header().Set("Access-Control-Allow-Headers","Content-Type");
        
        postbookid(db,w , r );

});
//?===-=-===-===-===-===-===-===-===-===-===-===-===-=-=-=-=-=-=-=-================
//!GET /get
router.Get("/get",func(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Access-Control-Allow-Origin", "*");
  w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
  w.Header().Set("Access-Control-Allow-Headers","Content-Type");

  get_db_book_to_flutter(db,w,r,&forflutter);
  });
  
  //!end of GET /get
  //?===-=-===-===-===-===-===-===-===-===-===-===-===-=-=-=-=-=-=-=-================
  //!start of GET /getother
  router.Get("/getother",func(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Access-Control-Allow-Origin", "*");
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
          w.Header().Set("Access-Control-Allow-Headers","Content-Type");
 
    _=get_others_to_flutter(db,w,r);
  });
  //!end of GET /getother
  //?===-=-===-===-===-===-===-===-===-===-===-===-===
//!start of POST for /getother
  router.Post("/getother",func(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Access-Control-Allow-Origin", "*");
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
          w.Header().Set("Access-Control-Allow-Headers","Content-Type");
          
          post_others_to_flutter(db,w , r );

  });
  //!end of POST /getother

router.Get("/",func(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Access-Control-Allow-Origin", "*");
  w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        w.Header().Set("Access-Control-Allow-Headers", "Content-Type");
  
});
//!start of PUT /posttime
router.Post("/posttime",func(w http.ResponseWriter, r *http.Request) {
  fmt.Print("hello doraemon")
  w.Header().Set("Access-Control-Allow-Origin", "*")
  w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT")
        w.Header().Set("Access-Control-Allow-Headers","Content-Type")
fmt.Print("hello \n\n\n")
  posttimes(db, w, r)
});

fmt.Print("hello ffrom golang server======")

http.ListenAndServe(":8080",router);
};

