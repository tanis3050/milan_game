// WORTH YOUR TIME
// Single-file 7-day Ink story.
// Player-visible wording is taken from the supplied outline wherever wording was provided.
// Anything not yet written in the outline is marked [PLACEHOLDER].
VAR location = "Worth your time"
VAR money = 0
VAR day = 1
VAR total_minutes = 480

// Hidden stats
VAR mental_health = 60
VAR fitness = 60
VAR food = 60
VAR sleep = 60
VAR skill = 0
VAR poor_eating_days = 0

// Story balance
VAR decent_mental_health = 60
VAR low_mental_health = 50
VAR very_low_mental_health = 20
VAR faint_threshold = 20

VAR base_work_pay = 500
VAR skill_pay_bonus = 2
VAR overtime_pay = 500

VAR work_time = 240
VAR overtime_time = 300
VAR breakfast_time = 30
VAR meal_with_coworker_time = 45
VAR meal_alone_time = 30
VAR hostel_walk_time = 30
VAR shower_time = 30
VAR exercise_time = 60
VAR social_time = 60
VAR study_time = 60
VAR sleep_time = 600

// Hidden daily maintenance thresholds.
// At the end of each day, the relevant stat drops naturally.
// If it is low enough, missing that action also causes an immediate mental-health debuff.
VAR exercise_daily_loss = 5
VAR food_daily_loss = 10
VAR sleep_daily_loss = 10

VAR fitness_action_gain = 10
VAR food_action_gain = 30
VAR sleep_action_gain = 60

VAR fitness_mental_threshold = 65
VAR food_mental_threshold = 60
VAR sleep_mental_threshold = 60

VAR fitness_mental_penalty = 5
VAR food_mental_penalty = 5
VAR sleep_mental_penalty = 5
VAR sleep_fitness_penalty = 5
VAR food_fitness_penalty = 3

// Once-per-day actions. Each action adds its tag here; the list is cleared in end_day.
LIST done_today = did_eat, did_shower, did_exercise, did_study, did_hangout, did_rest, did_scroll
VAR is_morning = true   // false once you leave for work; breakfast is only offered in the morning

// The story begins here. Keep this divert immediately after the VAR declarations.
-> game_start


=== game_start ===

~ location = "Worth your time"
worth your time.

+ Start the game
    -> day1_start

+ Finish(I aint play ts)
    -> END


=== day1_start ===

~ location = "hostel"
its the first day of your mid-sem break.A month ago you'd thought that this would be nice break and get to relax at home.but things didn't go as expected.With your dad losing his job as AI replaced him.Your household lost its only source of income. So, as too not put too much of a burden on your family you decide to take a part-time job, to pay off your educational loan emi of 5,000. by the end of the week. So would you go directly or take your time ?
-> day1_prework


=== day1_prework ===
+ head to work.
    -> first_day_at_work

+ { can_eat() } eat food.
    ~ eat_food()
    -> day1_prework

+ { can_shower() } take a shower.
    ~ take_shower()
    -> day1_prework


=== first_day_at_work ===

~ location = "office"
~ is_morning = false
Steping out of the auto,you look at your  new office
its not what you expected your first job to be.but atleast its something.you make your way to your new office.

+ head inside
    -> first_day_inside


=== first_day_inside ===
making your way to the manager's office and he makes you familiar with your work.
and arrive at your work-desk.

you work as a 3d modeller and animation. you hoped to one day make a career out of it.But as the rise of AI,this field is slowing shrinking.
boss- "here this is garima,you can ask her anything if youre stuck"
he introduces you to her.
and gets back to his work.

+ small talk 1 with co-worker
    you talk a little about where your from and how did you got into 3d modelling
    ~ mental_health += 5
    -> first_day_work_start

+ get to work.
    -> first_day_work_start


=== first_day_work_start ===
    you finally go to your desk and start working, you are basically paid for what you make so if you work faster you can earn more.You start up slow but quickly pick up the pace.


~ total_minutes += work_time
~ money += base_work_pay + skill * skill_pay_bonus
~ sleep -= 10
~ fitness -= 2

4 hours passes and you get some work done.

-> first_day_lunch


=== first_day_lunch ===

+ eat with co worker
    you make small talk to garima.And she also teaches you small shortcuts and techniques you didn't know about
    ~ total_minutes += meal_with_coworker_time
    ~ food += 25
    ~ skill += 5
    -> first_day_evening_shift

+ eat alone
    ~ total_minutes += meal_alone_time
    ~ food += 25
    -> first_day_evening_shift

+ skip lunch
    ~ food -= 20
    ~ mental_health -= 2
    
    -> first_day_evening_shift


=== first_day_evening_shift ===
well since you get paid by the work. you can stay or head out.
work evening shift

+ do overtime.
    ~ overtime_work()
    -> hostel_after_work

+ go back to hostel.
    ~ total_minutes += hostel_walk_time
    -> hostel_after_work


=== hostel_after_work ===

~ location = "hostel"
going home-
you make your way to the hostel after a tired day at work. its a bit of a mess but youre used to it.
what would you do ?
-> evening_hub


=== day_start ===

~ location = "hostel"
you wake up. what do you wanna do today ?

{ can_leave_bed():
    -> daily_actions
- else:
    -> bedbound_day
}


=== daily_actions ===
// Morning hub: at most 4 options on screen.
+ go to work.
    -> leave_for_work

+ { body_left() } [Look after yourself]
    -> body_menu -> daily_actions

+ { free_left() } [Free time]
    -> free_menu -> daily_actions

+ [Stay in bed]
    -> bed_menu -> daily_actions


=== leave_for_work ===
{ money >= 5000:
    -> work_or_quit
}
-> commute


=== work_or_quit ===
you already have enough for the emi. you could stop here.

+ go to work anyway.
    -> commute

+ leave job
    -> ending_check


=== commute ===
~ location = "office"
~ is_morning = false
{
    - mental_health <= very_low_mental_health:
        you make your way to the outside. and feel like everyone is looking at you. Can't help but feel its cause your so ugly.you don't know where that came from, nobody has told you that.but deep down you feel its the truth.

    - mental_health <= low_mental_health or sleep <= sleep_mental_threshold:
        you drag your body to the office,while looking at the ground.you have a mild headache and just wanna go back to your room. But you manage to push throught and make it to the office.

    - else:
        you make your way to you office. looking at the scenerary, and the morning sun.
}

-> work_shift


=== work_shift ===
{ mental_health <= very_low_mental_health:
    out of habit you move your body to the place its required.and sit down. and stare at the screen for some time wondering why you are even doing all this, atp you don't even care about getting kicked out of college. and don't feel like doing anything.
    you sloppily start something, mostly to atleast seem like your working and OK to others.regardless they don't care if you are here or not. they just want this work to be done.They would probably be happier if they could 3d model with AI on its own and won't need to see me anymore.
- else: 
    { - mental_health <= low_mental_health || sleep <= sleep_mental_threshold:
    you drag your body to the workdesk,while looking at the ground.already feeling tired, you dreading how you'll spend the next 4 hours here. anyway you start to work.hours pass slowly and eventually lunchtime/over arrives.
    -  else:
    you make your way to you seat, waving and making small talk with people before starting your work, and start up slow and slowly pick up the pace. just focusing on your work.
    }
}

~ total_minutes += work_time
~ money += base_work_pay + skill * skill_pay_bonus
~ sleep -= 10
~ fitness -= 2

you have your lunch in the middle and now have to decide what to do.

+ do overtime.
    ~ overtime_work()
    -> evening_after_work

+ go back to hostel.
    ~ total_minutes += hostel_walk_time
    -> evening_after_work


=== evening_after_work ===

~ location = "hostel"
you make your way to the hostel after a tired day at work. its a bit of a mess but youre used to it.
what would you do ?
-> evening_hub


=== evening_hub ===

~ location = "hostel"
// Evening hub: at most 4 options on screen.
+ { body_left() } [Look after yourself]
    -> body_menu -> evening_hub

+ { free_left() } [Free time]
    -> free_menu -> evening_hub

+ [Wind down for the night]
    -> bed_menu -> evening_hub


=== body_menu ===
{ not body_left():
    ->->
}

+ { can_eat() } eat food.
    ~ eat_food()
    -> body_menu

+ { can_shower() } take a shower.
    ~ take_shower()
    -> body_menu

+ { can_exercise() } exercise.
    ~ exercise()
    -> body_menu

+ [Back]
    ->->


=== free_menu ===
{ not free_left():
    ->->
}

+ { can_study() } learn/improve work skills.
    ~ study_skills()
    -> free_menu

+ { can_hangout() } hangout with friends.
    ~ socialize()
    -> free_menu

+ { can_rest() } rest.
    ~ rest()
    -> free_menu

+ [Back]
    ->->


=== bed_menu ===
+ { can_scroll() } doomscroll.
    ~ doomscroll()
    -> bed_menu

+ sleep
    ~ sleep_now()
    ->-> end_day

+ skip the day.
    { day == 1:
        This game is so boring, you think to yourself.
    }
    ->-> end_day

+ [Back]
    ->->


=== bedbound_day ===

~ location = "hostel"
you can't do this anymore. you just don't care anymore.
You can't sleep to bring your self to get out of bed.

+ sleep
    ~ sleep_now()
    -> end_day


=== end_day ===

// Missing exercise is punished immediately; no exercise_today flag is needed.
~ fitness -= exercise_daily_loss
{ fitness <= fitness_mental_threshold:
    ~ mental_health -= fitness_mental_penalty
}

// Poor eating has no grace period. The first poor-eating day is affected immediately.
~ food -= food_daily_loss
{ food <= food_mental_threshold:
    ~ poor_eating_days += 1
    ~ mental_health -= food_mental_penalty + poor_eating_days
    ~ fitness -= food_fitness_penalty
- else:
    ~ poor_eating_days = 0
}

// Missing sleep is punished immediately and also affects fitness.
~ sleep -= sleep_daily_loss
{ sleep <= sleep_mental_threshold:
    ~ mental_health -= sleep_mental_penalty
    ~ fitness -= sleep_fitness_penalty
}

// Keep hidden stats in range.
{ mental_health < 0:
    ~ mental_health = 0
}
{ fitness < 0:
    ~ fitness = 0
}
{ food < 0:
    ~ food = 0
}
{ sleep < 0:
    ~ sleep = 0
}
{ skill < 0:
    ~ skill = 0
}

// New day: every action is available again.
~ done_today = ()
~ is_morning = true

{ day >= 7:
    -> ending_check
}

~ day += 1
-> day_start


=== ending_check ===
{ money >= 5000:
    { mental_health >= decent_mental_health:
        -> good_ending
    - else:
        -> bad_mental_health_ending
    }
- else:
    { mental_health >= decent_mental_health:
        -> neutral_ending
    - else:
        -> bad_mental_health_ending
    }
}


=== good_ending ===
You finally did it. at first it seemed like a big hurdle. but now that its over,it doesn't feel that bad.you maintained your job without sacrifiging much of your mental health. People think "time is money" means that they can convert time into money without realizing that money is not everything and they don't even realize  what they are losing by only chasing money. Time is money can imply that time is just as importatnt as money but it is much more than that.Glad you didn't chase only money but also did the side-quests in this game. hope you follow the side quests of you life also.
-> END


=== neutral_ending ===
The dreaded day arrives and what you feared came true. but at last. your friends help you cover the remaining money that you needed. you think why didn't i think of this first. you spend the rest of the day with friends.
-> END


=== bad_mental_health_ending ===
 You just don't care anymore. even though you try your best you aren't enough. you don't see a point in doing anything. I know that you were trying to get money but why ? just to pay off your debts. and what after that. again continue the grind ? and why and what for ? everyday feels the same. The same old boring feeling, that feeling of meaninglessness of not knowing what would make you happy. you don't know when this feelings first started.but they are certainly there now. inside you,and tearing you apart. I don't see anything in the future. was it really worth your time to grind for all that money. did I really need it ? I don't know
-> END


// --------------------------------------------------
// FUNCTIONS
// --------------------------------------------------

=== function eat_food() ===
    {food>food_mental_threshold:
going out in the morning sun feels good on your skin.as you feel your body slowing waking up. and eating the best meal of the day,(atleast in mess).you feel full and ready to start the day.
    - else:
    you rush to the way to mess and its a nice break to go for breakfast once in while. you arrive just before closing time, and eat the what ever is left over.
}
~ total_minutes += breakfast_time
~ food += food_action_gain
~ done_today += did_eat


=== function take_shower() ===
    The cold water feels nice, you feel refreshed.
~ total_minutes += shower_time
~ done_today += did_shower


=== function exercise() ===
    exercising always feels better than you expect and you think I should do it more often.
~ total_minutes += exercise_time
~ fitness += fitness_action_gain
~ done_today += did_exercise


=== function socialize() ===
    You catch up with your friends.You take about random stuff making small jokes.It makes your worries about the future seem a bit small.and you feel in the moment.
~ total_minutes += social_time
~ mental_health += 8
~ done_today += did_hangout


=== function study_skills() ===
    you sit down at your desk reading documentation and making notes. You used to enjoy this. but now it feels like work and you feel you lost your curiosity and amazement that you used to get from just messing around. you push away these thought and learn something new.
~ total_minutes += study_time
~ skill += 5
~ done_today += did_study


=== function rest() ===
you lie down. and rest for a while. no phone. no music. just you and your thoughts. it feels nice.
~ total_minutes += 60
~ sleep += 10
~ done_today += did_rest


=== function doomscroll() ===
you pass the time while scrolling,you thought you'll just watch for 5 mins but before you know it, an hour has passed.
~ total_minutes += social_time
~ mental_health -= 5
~ sleep -= 5
~ done_today += did_scroll


=== function sleep_now() ===
{ sleep>sleep_mental_threshold:
    you turn down the lights and head to bed, it feels soft and all you fatigue of the day melts away.
  - else:
    you turn off the lights but aren't able to fall asleep.you stare at the ceiling tossing and turning,thinking about how it got so bad.you have nothing to look forward to. feeling you're just struggling to survive while others are enjoying their "college life" yet you don't know what to do even if you had no work.overthinking about your life you fall asleep.
 
}
~ total_minutes += sleep_time
~ sleep += sleep_action_gain

=== function overtime_work() ===
you decide to put in some extra work, as you are worried about being short on money
~ total_minutes += overtime_time
~ money += overtime_pay
~ sleep -= 15
~ fitness -= 3

=== function can_leave_bed() ===
{ fitness <= faint_threshold:
    ~ return false
- else:
    ~ return true
}


// Availability checks for once-per-day actions and menu bundles.
=== function can_eat() ===
~ return is_morning and not (done_today ? did_eat)

=== function can_shower() ===
~ return not (done_today ? did_shower)

=== function can_exercise() ===
~ return not (done_today ? did_exercise)

=== function can_study() ===
~ return not (done_today ? did_study)

=== function can_hangout() ===
~ return not (done_today ? did_hangout)

=== function can_rest() ===
~ return not (done_today ? did_rest)

=== function can_scroll() ===
~ return not (done_today ? did_scroll)

=== function body_left() ===
~ return can_eat() or can_shower() or can_exercise()

=== function free_left() ===
~ return can_study() or can_hangout() or can_rest()

