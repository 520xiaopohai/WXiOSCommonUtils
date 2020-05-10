# LGtitleBar
UICollectionView 仿导航栏滑动效果UISegmentedControl


#### 使用方法:

  将LGTitleBar里面的4个文件拖入到工程中就可以使用啦：

```
//tintColor 设置titleBar的主题色

LGtitleBarView *titleBar = [[LGtitleBarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 45)];
    self.titles = @[@"我的商城", @"我的优惠券", @"团购券", @"积分商城", @"微信", @"微博", @"墨迹天气"];
    titleBar.titles = self.titles;
    titleBar.tintColor = [UIColor yellowColor];
    titleBar.delegate = self;
    [self.view addSubview:titleBar]; 
```
      
    
    
#### 然后实现代理方法：

    -(void)LGtitleBarView:(LGtitleBarView *)titleBarView didSelectedItem:(int)index
     {
      NSLog(@"%d", index);
     // 以下代码为我测试用的
      NSString *str = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@", self.titles[index]];
      str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      NSURL *url = [NSURL URLWithString:str];
      NSURLRequest *request = [NSURLRequest requestWithURL:url];
      [self.webView loadRequest:request];
     }




