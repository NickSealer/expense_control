# README

Application to manage expenses and budget to help to control the finances.

## Basic steps to enable a notification system using Hotwire


#### Pre requisites
* Create the rails 7 app 
* Setup DB
* Setup model, views, controller, routes

In this example there are:
* Notification model, 
* Notificationcontroller (CRUD)
* Notification views (index method) 

#### Steps:
1. Init redis:
  ```
  redis-server
  ```
2. Run rails command:
  ```
  bin/rails turbo:install
  ```
3. Broadcast the channel in **Notification** model:
  ```ruby
  after_create_commit -> { broadcast_replace_to(:channel_name, target: "turbo_frame_tag_name", partial: "your/partial") }
  ```
4. Subscribe to the channel, is recommended do it before the dynamic HTML code:
  ```erb
  <%= turbo_stream_from(:channel_name) %>
  Dynamic HTML code...
  ```
6. The HTML code that will interact with TurboStream:
  ```erb
  <%= turbo_frame_tag 'turbo_frame_tag_name' do %> 
    <%= render 'your/partial' %>
  <% end %>
  ```
8. The partial:
  ```erb
  <p>
    <%= Notification.count %>
  <p>
  ```
## Notification system

### Get new Notification counter
1. Model:
   Via callback in **Notification** model
   ```ruby
    after_save :broadcast_count_notification
    ```
   Custom method to use the current user. This is because Turbo partials are rendered by the ApplicationRenderer, not within the context of a specific request.
   ```ruby
   def broadcast_count_notification
     broadcast_replace_to(:notifications, target: 'notification_count', partial: 'notifications/count', locals: { user: user })
   end
    ```
2. View:
  app/views/notifications/_count.html.erb
   ```erb
   <%= turbo_frame_tag 'notification_count' do %>
     <span class="notification_count"><%= user.unread_notification_count %></span>
   <% end %>
   ```

### Get deleted Notification counter
1. Model:
   Is the same that the previous section, but the callback is different
   ```ruby
   after_destroy_commit :broadcast_count_notification
   ```

### Create Notification
1. Model:
   ```ruby
   after_create_commit :broadcast_create_notification
   ```
   Custom method to display the notifications to the right current user
   ```ruby
   def broadcast_create_notification
     broadcast_prepend_to(:notification_content, target: "notification-content-#{user.id}", partial: 'notifications/notification')
   end
   ```
2. View:
   app/views/notifications/_notification_content.html.erb
   ```erb
    <%= turbo_stream_from(:notification_content) %>
    <div class="notification-content" id="notification-content-<%= current_user.id %>">
      <% current_user.notifications.order(:id).reverse.each do |notification| %>
        <%= render 'notifications/notification', notification: notification %>
      <% end %>
    </div>
   ```
   app/views/notifications/_notification.html.erb
   ```erb
   <div id="<%= dom_id notification %>" class="notification-card read_<%= notification.read %>">
      <%= link_to notification.url, class:  "notification-url-js", data: { id: notification.id } do %>
        <section>
          <p><%= notification.id %> <%= notification.message %></p>
          <span class="read">Read: <%= notification.read_at&.strftime('%y/%m/%d %T') %></span>
          <span class="time-ago"><%= time_ago_in_words(notification.created_at) %></span>
        </section>
      <% end %>
      <span class="read_<%= notification.read %> notification-actions" data-id="<%= notification.id %>">
        <span id="read_<%= notification.id %>" class="notification-option-js" data-id="<%= notification.id %>" data-action="update">Mark as read</span>
        <span id="delete_<%= notification.id %>" class="notification-option-js" data-id="<%= notification.id %>" data-action="delete">Delete</span>
      </span>
    </div>
   ```
4. Model expense
   The notification is created through the **after_create** callback in the **Expense** model.

### Update Notification
1. Model:
   ```ruby
   after_update_commit -> { broadcast_replace_to(:notification_content, partial: 'notifications/notification') }
   ```
2. View:
  Internally Turbo recognize the **Notification** id and dom id, this is possible using **dom_id(notification)** helper method in the app/views/notifications/_notification.html.erb
   ```erb
   <div id="<%= dom_id notification %>" class="notification-card read_<%= notification.read %>">
     Rest of the code...
   </div>
   ```
4. Controller
   Responds as turbo_stream format. You can use update.turbo_stream.erb file or model callback as I did.
   ```ruby
   def update
     notification.read! unless notification.read
     respond_to(&:turbo_stream)
   end
   ```
   
### Delete Notification
1. Model:
   As you can see the ***broadcast...* method is shorter, this is thanks to Ruby on Rail conventions 🚀
   ```ruby
   after_destroy_commit -> { broadcast_remove_to(:notification_content) }
   ```
3. View:
   Turbo searches the object dom id and remove the complete html piece of code
4. Controller
   Responds as turbo_stream format. You can use update.turbo_stream.erb file or model callback as I did.
   ```ruby
   def destroy
     notification.destroy!
     respond_to(&:turbo_stream)
   end
   ```