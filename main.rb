require 'io/console'

def slot_start()                                        # 使用するコインを選択する
    puts("コイン何枚入れますか")
    puts("1(10コイン) 2(30コイン) 3(50コイン) 4(やめとく)")
    bet = gets.chomp.to_i

    if bet == 1
        bet_coin = 10
    elsif bet == 2
        bet_coin = 30
    elsif bet == 3
        bet_coin = 50
    elsif bet == 4
        puts("やーめよ")
        exit
    end

    return bet, bet_coin                                # 処理用の数値と、表示用のコインを返す
end

def slot_reel()                                         # 数値を３つランダムで生成する
    num1 = Random.rand(1..9)
    num2 = Random.rand(1..9)
    num3 = Random.rand(1..9)
    return num1, num2, num3
end

def per_slot(place, number, coin, bet_coin, point)    # 当たった時の処理
    puts("！！大当たり！！")
    puts("#{place}に#{number}が揃いました")
    coin += bet_coin * 3
    point += 500
    puts("#{bet_coin * 3}枚のコインを獲得！！")
    puts("#{point}ポイント獲得！！")
    per = true                                 # 変数を当たりにする
    return coin, per, point
end

coin = 100                                                # コインの枚数
point = 0
per = false                                               # 当たり外れの変数
game_again = 1                                            # ゲーム開始の変数
puts("残りコイン枚数#{coin}")
puts("ポイント#{point}")

while game_again == 1
    bet_coin = 0

    bet, bet_coin = slot_start()

    while bet ==0 || bet >= 5 || coin < bet_coin          # 数値が正しく選択されていないまたは、賭けたコインが手持ちよりも多い場合に再入力をする処理
        if bet == 0|| bet >= 5
            puts("1-4で選んでください")
        else
            puts("現在#{coin}枚のコインを所持しています")
            puts("coinが足りません")
        end
        bet, bet_coin = slot_start()
    end

    coin -= bet_coin                                      # 賭けたコインを減算
    puts("--------------")
    puts("エンターを3回押してください")

    slot_top = [0, 0, 0]                                  # スロットの上段、中段、下段を配列に入れる
    slot_center = [0, 0, 0]
    slot_bottom = [0, 0, 0]

    for i in 1..3 do                                      # スロットを3回回す
        key = STDIN.getch                                 # 押されたキーを取得
        while key != "\r"
            puts("エンターを押してください")
            key = STDIN.getch
        end
        if (key == "\r")
            slot_top[i-1], slot_center[i-1], slot_bottom[i-1] = slot_reel()     # スロットの上段、中段、下段それぞれにランダムで値を代入
            if i == 1
                puts("|#{slot_top[0]}| | |")
                puts("|#{slot_center[0]}| | |")
                puts("|#{slot_bottom[0]}| | |")
            elsif i == 2
                puts("|#{slot_top[0]}|#{slot_top[1]}| |")
                puts("|#{slot_center[0]}|#{slot_center[1]}| |")
                puts("|#{slot_bottom[0]}|#{slot_bottom[1]}| |")
            elsif i == 3
                puts("|#{slot_top[0]}|#{slot_top[1]}|#{slot_top[2]}|")
                puts("|#{slot_center[0]}|#{slot_center[1]}|#{slot_center[2]}|")
                puts("|#{slot_bottom[0]}|#{slot_bottom[1]}|#{slot_bottom[2]}|")
            end
            puts("--------------")
        end
    end


    if [slot_top[0], slot_top[1], slot_top[2]].uniq.count == 1                 # スロットが揃った時の処理
        coin, point, per = per_slot("上段", slot_top[0], coin, bet_coin, point)
    end
    if [slot_center[0], slot_center[1], slot_center[2]].uniq.count == 1
        coin, point, per = per_slot("真ん中", slot_center[0], coin, bet_coin, point)
    end
    if [slot_bottom[0], slot_bottom[1], slot_bottom[2]].uniq.count == 1
        coin, point, per = per_slot("下段", slot_bottom[0], coin, bet_coin, point)
    end
    if per == false                                                           # スロットで外れた処理
        puts("残念、ハズレ")
        if coin < 10                                       # コインが少なくなったら強制終了
            puts("現在のコインは#{coin}枚です")
            puts("coinがなくなりました。")
            puts("また遊んでくださいね")
            exit
        end
    end

    puts("残りコイン枚数#{coin}")
    puts("--------------")
    puts("続けて遊びますか？")
    puts("1(Yes) 2(No)")
    game_again = gets.chomp.to_i
    if game_again != 1                                     # ゲームをしない場合
        puts("ご利用ありがとうございました。")
        puts("また遊んでくださいね")
    end
end